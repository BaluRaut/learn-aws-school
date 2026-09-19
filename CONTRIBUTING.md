# 🤝 Contributing to Learn AWS School

Corrections are the school's favourite kind of homework. Three easy ways to help:

## 🐛 Found a mistake?
Open an issue: <https://github.com/BaluRaut/learn-aws-school/issues>. Say which lesson/branch,
quote the sentence, and (if you know) what it should say. Technical accuracy beats analogy —
if the analogy misleads, we fix the analogy.

## 🇮🇳 Better Marathi
The site ships Marathi by default; the English original sits in a `data-en` attribute on each
translated element. The dictionary lives in the portal repo:
<https://github.com/BaluRaut/school/tree/main/i18n> (`mr.json`, English fragment → Marathi).
Fix the entry there, or just open an issue with the English line and your better Marathi.
Register we use: technical nouns stay in Latin script (IAM, Pod, RAG), analogy words go Marathi.

## 🧪 Extra lab ideas
Each lesson is one git branch (`lesson-NN-topic`) with `lessons/NN-topic/README.md` and any lab
files (Terraform in `vpc/`, `ec2/`, `waf/`, `apigw/`…). A good lab: ~10 minutes, pennies at most,
ends with `terraform destroy`, and has a **Verify** line (what you should see) and a **Clean up**
line. Propose it in an issue first — we keep the course at 25 lessons on purpose.

## Rules of the house
- One idea per branch; branches are cumulative (branch 07 contains lessons 01–07).
- Every lesson keeps the skeleton: What's in this branch · ELI5 · Diagram · What · Why · How ·
  Try it · Verify · Clean up · Common mistakes · Next.
- Numbers must be true or clearly marked as estimates; no unsupported percentages.
- MIT licensed — by contributing you agree your text can be used under the same license.
