---
title: "Blog"
layout: default
permalink: /blog
---

# Blog

{% for post in site.posts %}
- **[{{ post.title }}]({{ post.url }})** — {{ post.date | date: "%B %d, %Y" }}
{% endfor %}
