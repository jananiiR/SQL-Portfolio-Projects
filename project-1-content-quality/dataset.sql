CREATE TABLE content_qa_log (
  record_id      INTEGER PRIMARY KEY,
  content_title  TEXT,
  content_type   TEXT,   -- 'Movie', 'Series', 'Documentary'
  region         TEXT,   -- 'IN', 'US', 'UK', 'AU'
  qa_status      TEXT,   -- 'Pass', 'Fail', 'Pending'
  defect_type    TEXT,   -- 'Metadata', 'Audio', 'Subtitles', NULL if Pass
  review_date    DATE,
  reviewer_id    INTEGER
);

INSERT INTO content_qa_log VALUES
(1,  'The Last Hope',    'Movie',       'IN', 'Pass', NULL,        '2024-01-05', 101),
(2,  'Coastal Dreams',   'Series',      'US', 'Fail', 'Metadata',  '2024-01-05', 102),
(3,  'Wild Earth',       'Documentary', 'UK', 'Pass', NULL,        '2024-01-06', 101),
(4,  'City Lights',      'Series',      'IN', 'Fail', 'Audio',     '2024-01-06', 103),
(5,  'Storm Season',     'Movie',       'AU', 'Pass', NULL,        '2024-01-07', 102),
(6,  'The Verdict',      'Movie',       'IN', 'Fail', 'Subtitles', '2024-01-07', 101),
(7,  'Ocean Deep',       'Documentary', 'US', 'Pass', NULL,        '2024-01-08', 103),
(8,  'Family Ties',      'Series',      'UK', 'Pending', NULL,     '2024-01-08', 102),
(9,  'Rise Again',       'Movie',       'IN', 'Pass', NULL,        '2024-01-09', 101),
(10, 'Arctic Wanderer',  'Documentary', 'AU', 'Fail', 'Metadata',  '2024-01-09', 103),
(11, 'Dark Horizons',    'Series',      'US', 'Pass', NULL,        '2024-01-10', 102),
(12, 'Silent Valley',    'Movie',       'IN', 'Fail', 'Audio',     '2024-01-10', 101);

SELECT
  qa_status,
  COUNT(*) AS total_records
FROM content_qa_log
GROUP BY qa_status
ORDER BY total_records DESC;

SELECT
  defect_type,
  COUNT(*) AS failure_count
FROM content_qa_log
WHERE qa_status = 'Fail'
GROUP BY defect_type
ORDER BY failure_count DESC;

SELECT
  content_type,
  COUNT(*) AS total,
  SUM(CASE WHEN qa_status = 'Pass' THEN 1 ELSE 0 END) AS passed,
  ROUND(
    100.0 * SUM(CASE WHEN qa_status = 'Pass' THEN 1 ELSE 0 END) / COUNT(*),
    1
  ) AS pass_rate_pct
FROM content_qa_log
GROUP BY content_type
ORDER BY pass_rate_pct ASC;

SELECT
  region,
  COUNT(*) AS total_failures
FROM content_qa_log
WHERE qa_status = 'Fail'
GROUP BY region
ORDER BY total_failures DESC;

