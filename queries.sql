-- Лабораторная работа №2. Вариант 12
-- Используются таблицы Teachers и Workload из лабораторной №1

-- 1. Преподаватели без высшего образования со стажем от 3 до 10 лет
SELECT *
FROM Teachers
WHERE Education <> 'высшее'
  AND Experience BETWEEN 3 AND 10;

-- 2. Преподаватели с фамилиями на буквы от «А» до «К», оплата часа не ниже 150 руб.
SELECT DISTINCT t.*, w.Hour_cost
FROM Teachers t
JOIN Workload w ON w.Teacher_ID = t.Teacher_ID
WHERE t.Last_name ~ '^[А-К]'
  AND w.Hour_cost >= 150;

-- 3. Таблица с данными 2 запроса (с контактными телефонами)
SELECT DISTINCT t.Teacher_ID, t.Last_name, t.First_name, t.Middle_name,
       t.Education, t.Experience, t.Department_number, t.Phone
INTO Selected_teachers
FROM Teachers t
JOIN Workload w ON w.Teacher_ID = t.Teacher_ID
WHERE t.Last_name ~ '^[А-К]'
  AND w.Hour_cost >= 150;

-- 4. Добавить в созданную таблицу преподавателей из 1 запроса (Insert Select)
INSERT INTO Selected_teachers
SELECT Teacher_ID, Last_name, First_name, Middle_name,
       Education, Experience, Department_number, Phone
FROM Teachers
WHERE Education <> 'высшее'
  AND Experience BETWEEN 3 AND 10
  AND Teacher_ID NOT IN (SELECT Teacher_ID FROM Selected_teachers);

-- 5. Изменить код 499 на 495 в телефонах (Update)
UPDATE Selected_teachers
SET Phone = REPLACE(Phone, '(499)', '(495)')
WHERE Phone LIKE '%(499)%';

-- 6. Удалить преподавателей без контактного телефона (Delete)
DELETE FROM Selected_teachers
WHERE Phone IS NULL;

-- 7. Количество дисциплин каждого преподавателя и средняя оплата часа (групповой запрос)
SELECT t.Teacher_ID, t.Last_name,
       COUNT(w.Subject_ID)        AS Subjects_count,
       ROUND(AVG(w.Hour_cost), 2) AS Avg_hour_cost
FROM Teachers t
LEFT JOIN Workload w ON w.Teacher_ID = t.Teacher_ID
GROUP BY t.Teacher_ID, t.Last_name
ORDER BY t.Teacher_ID;
