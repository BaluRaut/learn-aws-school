# ⚡ Lesson 19 — the entire "server". No desk, no port, no process to keep alive.
# The helper appears, runs handler(), vanishes. print() lands in the CloudWatch diary.

def handler(event, context):
    name = (event or {}).get("name", "world")
    print(f"errand received: greet {name!r}")          # → CloudWatch Logs, automatically
    return {"greeting": f"hello, {name}"}
