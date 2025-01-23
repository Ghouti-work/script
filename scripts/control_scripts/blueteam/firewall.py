import subprocess
import time
from collections import defaultdict
from datetime import datetime, timedelta

from scapy.all import *

scan_tracker = defaultdict(lambda: {"count": 0, "timestamp": None})

BLOCK_DURATION = timedelta(minutes=10)


def is_ip_blocked(ip):
    result = subprocess.run(["iptables", "-L", "-n"], stdout=subprocess.PIPE, text=True)
    return ip.encode() in result.stdout


def block_ip(ip):
    if not is_ip_blocked(ip):
        print(f"Blocking {ip}")
        try:
            subprocess.run(
                ["iptables", "-A", "INPUT", "-s", ip, "-j", "DROP"], check=True
            )
        except subprocess.CalledProcessError as e:
            print(f"Failed to block {ip}: {e}")
    else:
        print(f"{ip} is already blocked")
        return


def unblock_ip(ip):
    print(f"Unblocking {ip}")
    try:
        subprocess.run(["iptables", "-D", "INPUT", "-s", ip, "-j", "DROP"], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Failed to unblock {ip}: {e}")


def handle_packet(packet):
    if TCP in packet and packet[TCP].flags == "S":
        src_ip = packet[IP].src
        port = packet[TCP].dport
        src_port = packet[TCP].sport

        print(f"SYN packet from {src_ip}:{src_port} to port {port}")

        current_time = datetime.now()
        if (
            scan_tracker[src_ip]["timestamp"]
            and current_time - scan_tracker[src_ip]["timestamp"] > BLOCK_DURATION
        ):
            scan_tracker[src_ip] = {"count": 0, "timestamp": None}

        scan_tracker[src_ip]["count"] += 1
        scan_tracker[src_ip]["timestamp"] = current_time

        if scan_tracker[src_ip]["count"] > 5:
            print(
                f"IP {src_ip} exceeded the limit of 5 SYN packets, blocking for {BLOCK_DURATION}"
            )
            block_ip(src_ip)
            # Unblock after BLOCK_DURATION
            unblock_time = datetime.now() + BLOCK_DURATION
            print(f"Unblocking {src_ip} at {unblock_time.strftime('%H:%M:%S')}")
            sniff_thread.unblock_tasks.append(
                {"ip": src_ip, "unblock_time": unblock_time}
            )
            return

        # Send SYN-ACK
        syn_ack = IP(dst=src_ip, src=packet[IP].dst) / TCP(
            dport=src_port, sport=port, flags="SA", seq=100, ack=packet[TCP].seq + 1
        )
        send(syn_ack, verbose=0)
        print(f"Sent SYN-ACK to {src_ip}:{src_port}")

        # Send "Try Harder" message
        data_packet = (
            IP(dst=src_ip, src=packet[IP].dst)
            / TCP(
                dport=src_port, sport=port, flags="PA", seq=101, ack=packet[TCP].seq + 1
            )
            / Raw(load="Try harder")
        )
        send(data_packet, verbose=0)
        print(f"Sent 'Try Harder' to {src_ip}:{src_port}")


def unblock_expired_ip():
    now = datetime.now()
    for task in list(sniff_thread.unblock_tasks):
        if now >= task["unblock_time"]:
            unblock_ip(task["ip"])
            sniff_thread.unblock_tasks.remove(task)


class SniffThread:
    def init(self):
        self.unblock_tasks = []

    def start_sniffing(self):
        sniff(filter="tcp", prn=handle_packet)


sniff_thread = SniffThread()

if name == "main":
    import threading

    sniff_thread = SniffThread()
    sniff_thread_thread = threading.Thread(
        target=sniff_thread.start_sniffing, daemon=True
    )
    sniff_thread_thread.start()
    try:
        while True:
            unblock_expired_ip()
            time.sleep(5)
    except KeyboardInterrupt:
        print("Exiting")

