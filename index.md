---
layout: default
lang: ja
title: "法的ドキュメント一覧"
---

<h1 class="page-title">アプリ一覧</h1>

{% assign apps_grouped = site.apps | group_by: "app_id" | sort: "name" %}
<ul class="app-list">
  {% for group in apps_grouped %}
  {% comment %} アプリ説明は日本語版を優先して表示する {% endcomment %}
  {% assign ja_docs = group.items | where: "lang", "ja" %}
  {% assign first_doc = ja_docs | first | default: group.items.first %}
  <li class="app-list-item">
    <div class="app-name">{{ first_doc.app_name }}</div>
    {% if first_doc.description %}
    <div class="app-description">{{ first_doc.description }}</div>
    {% endif %}
    <ul class="doc-type-list">
      {% comment %} 文書種別ごとに、日本語版 → 他言語版の順で表示する {% endcomment %}
      {% assign doc_type_keys = group.items | map: "doc_type" | uniq | sort %}
      {% for doc_type_key in doc_type_keys %}
      {% assign docs_of_type = group.items | where: "doc_type", doc_type_key %}
      {% assign ja_docs_of_type = docs_of_type | where: "lang", "ja" %}
      {% assign other_docs_of_type = docs_of_type | where_exp: "d", "d.lang != 'ja'" | sort: "lang" %}
      {% assign sorted_docs = ja_docs_of_type | concat: other_docs_of_type %}
      {% for doc in sorted_docs %}
      <li>
        <a href="{{ doc.url | prepend: site.baseurl }}"{% if doc.lang %} hreflang="{{ doc.lang }}"{% endif %}>
          {% if doc.lang == 'en' %}{{ site.data.doc_types_en[doc.doc_type] | default: doc.doc_type }} (English){% else %}{{ site.data.doc_types[doc.doc_type] | default: doc.doc_type }}{% endif %}
        </a>
        <span class="app-meta">
          {% if doc.last_updated %}最終更新: {{ doc.last_updated }}{% endif %}
        </span>
      </li>
      {% endfor %}
      {% endfor %}
    </ul>
  </li>
  {% endfor %}
</ul>
