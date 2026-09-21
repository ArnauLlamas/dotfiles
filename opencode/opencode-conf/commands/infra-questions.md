---
description: Answer infrastructure/resiliency questions for potential customers by exploring repos.
---

You are helping answer a customer-facing infrastructure or resiliency question.

The question to answer is: $ARGUMENTS

If no question was provided, ask the user what the customer question is before proceeding.

Then ask the user for the repository paths to explore, unless they have already been provided.

Once you have both, explore the repositories to understand the hosting platform, compute and scaling strategy, networking, databases, caching, backups, and any off-site/SaaS dependencies. Do not fabricate or assume any details — only use what you find in the code.

Produce two clearly separated sections:

## For you (internal)
A brief summary of what you found: key infrastructure components, any gaps or caveats worth knowing before sending the answer to the customer (e.g. single points of failure, missing HA, external dependencies). Keep it factual and direct.

## Customer-facing answer
A fluent, professional prose response ready to copy-paste. No bullet points. No headings inside the answer. Generalist language — avoid overly specific internal naming, module names, or implementation details that add no value for the customer. Short, confident, and to the point.
