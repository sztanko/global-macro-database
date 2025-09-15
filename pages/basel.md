
---
title: Tabla Basel y evolución del percentil 50
---

```sql a
SELECT * FROM Basel
LIMIT 100;
```

```sql overall_score_2012
SELECT year, median("Overall score 2012") AS percentil_50
FROM Basel
GROUP BY year
ORDER BY year;
```
