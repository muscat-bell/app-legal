---
layout: default
lang: ja
title: "プライバシーポリシー一覧"
---

<h1 class="page-title">アプリ一覧</h1>

<ul class="app-list">
  {% assign sorted_apps = site.apps | sort: "app_name" %}
  {% for app in sorted_apps %}
  <li class="app-list-item">
    <a href="{{ app.url | prepend: site.baseurl }}">
      <div class="app-name">{{ app.app_name }}</div>
      {% if app.description %}
      <div class="app-description">{{ app.description }}</div>
      {% endif %}
      <div class="app-meta">
        {% if app.last_updated %}最終更新: {{ app.last_updated }}{% endif %}
        {% if app.lang %} &middot; 言語: {{ app.lang }}{% endif %}
      </div>
    </a>
  </li>
  {% endfor %}
</ul>
