---
layout: post
title: Openapi/swagger editor from docker
---

If you need to quickly edit or view a swagger/openapi spec, you can use the mighty swagger editor: https://github.com/swagger-api/swagger-editor

For a quick way to run it, use docker to run the editor itself:
```bash
docker pull swaggerapi/swagger-editor
docker run -d -p 8080:8080 swaggerapi/swagger-editor
```
Then open your browser on localhost to use the webapp.
```bash
xdg-open http://127.0.0.1:8080
```
