#!/usr/bin/env bash
# 🗄️ Lesson 14 lab — the visitor pass, start to finish (~0¢)
set -euo pipefail

BUCKET="school-lab-$RANDOM$RANDOM"
echo "🪣 claiming a locker wall: $BUCKET"
aws s3 mb "s3://$BUCKET"

echo "hello from the locker room, $(date)" > note.txt
echo "📦 filing a box under a tidy label..."
aws s3 cp note.txt "s3://$BUCKET/notes/2026/note.txt"

echo "🛡️ proving the default: strangers get nothing..."
URL_PLAIN="https://$BUCKET.s3.amazonaws.com/notes/2026/note.txt"
curl -s -o /dev/null -w "  no pass → HTTP %{http_code} (good — locked)\n" "$URL_PLAIN"

echo "🎟️ issuing a 60-second visitor pass..."
PASS=$(aws s3 presign "s3://$BUCKET/notes/2026/note.txt" --expires-in 60)
curl -s -o /dev/null -w "  with pass → HTTP %{http_code} (in!)\n" "$PASS"
echo "  pass says: $(curl -s "$PASS")"

echo "⏰ waiting 65s for the pass to expire..."
sleep 65
curl -s -o /dev/null -w "  expired pass → HTTP %{http_code} (locked again)\n" "$PASS"

echo "🧹 cleanup (lesson 20 habit: leave nothing running)..."
aws s3 rm "s3://$BUCKET" --recursive
aws s3 rb "s3://$BUCKET"
rm -f note.txt
echo "✅ done — the whole lab cost fractions of a cent."
