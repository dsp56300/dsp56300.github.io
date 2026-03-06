---
title: "Technical"
layout: default
permalink: /technical/
---

# Technical

{% for item in site.navigation %}
{% if item.title == "Technical" %}
{% for child in item.children %}
{% unless child.title contains "──" %}
- **[{{ child.title }}]({{ child.url }})**
{% endunless %}
{% endfor %}
{% endif %}
{% endfor %}
