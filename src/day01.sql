\i src/prelude.sql
copy raw_lines (line) from '../input/day01.txt';

with instructions as (
    select
        line_no as step,
        regexp_replace(regexp_replace(line, '^L', '-'), 'R', '')::int as diff
    from raw_lines
),
rotations as (
    select 0 as step, 50 as diff
    union all (select step, diff from instructions)
),
rotations_with_raw_positions as (
    select step, diff, mod(sum(diff) over (order by step), 100) as raw_position
    from rotations
),
positions as (
    select step, diff, case when raw_position < 0 then 100 + raw_position else raw_position end as position
    from rotations_with_raw_positions
)
select (select count(*) from positions where position = 0) as solution_part_1;
