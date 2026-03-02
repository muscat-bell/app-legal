---
layout: default
lang: ja
title: "法的ドキュメント一覧"
---

<h1 class="page-title">アプリ一覧</h1>

{% assign apps_grouped = site.apps | group_by: "app_id" | sort: "name" %}
<ul class="app-list">
  {% for group in apps_grouped %}
  {% assign first_doc = group.items | first %}
  <li class="app-list-item">
    <div class="app-name">{{ first_doc.app_name }}</div>
    {% if first_doc.description %}
    <div class="app-description">{{ first_doc.description }}</div>
    {% endif %}
    <ul class="doc-type-list">
      {% assign sorted_docs = group.items | sort: "doc_type" %}
      {% for doc in sorted_docs %}
      <li>
        <a href="{{ doc.url | prepend: site.baseurl }}">
          {{ site.data.doc_types[doc.doc_type] | default: doc.doc_type }}
        </a>
        <span class="app-meta">
          {% if doc.last_updated %}最終更新: {{ doc.last_updated }}{% endif %}
        </span>
      </li>
      {% endfor %}
    </ul>
  </li>
  {% endfor %}
</ul>
