\i src/prelude.sql
copy raw_lines (line) from '../input/day02.txt';

with recursive range_lines as (
    select regexp_split_to_table(line, ',') as range
    from raw_lines
),
ranges as (
    select split_part(range, '-', 1) as range_start, split_part(range, '-', 2) as range_end
    from range_lines
),
numbers as (
    select generate_series(ranges.range_start::bigint, ranges.range_end::bigint) as number
    from ranges
),
ids as (
    select number::text as id
    from numbers
),
repeats as (
   select id, null::text as part, 0 as size, null::text as repeat
   from ids
   union all
   select id, substr(id, 1, size + 1), size + 1, repeat(substr(id, 1, size + 1), length(id) / (size + 1))
   from repeats
   where size < length(id) / 2
),
one_repetition_patterns as (
    select id
    from repeats
    where id = repeat
    and size = length(id) / 2.0
),
max_repetition_patterns as (
    select id
    from (
        select id, max(size) as max_size
        from repeats
        where id = repeat
        group by id
    ) as grouped_repeats
)
select
    (select sum(id::bigint) from one_repetition_patterns) as solution_part_1,
    (select sum(id::bigint) from max_repetition_patterns) as solution_part_2;
