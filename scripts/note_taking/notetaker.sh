#!bin/sh

noteFilename="$HOME/Notes/journaling/note-$(date +%Y-%m-%d).md"

if [ ! -f $noteFilename ]; then
  echo "# notes for $(date +%Y-%m-%d)" >$noteFilename
fi

nvim -c "norm Go" \
  -c "norm Go## $(date +%H:%M)" \
  -c "norm G2o" \
  -c "norm zz" \
  -c "startinsert" $noteFilename
