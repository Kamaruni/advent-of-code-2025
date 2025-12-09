\i src/prelude.sql
copy raw_lines (line) from '../input/day04.txt';

with recursive grid as (
    select line_no as row, row_coordinates.col, row_coordinates.item
    from raw_lines, regexp_split_to_table(line, '') with ordinality as row_coordinates(item, col)
),
moves as (
    select
        g.row,
        g.col,
        g.item,
        0 as moved,
        0 as iterations
    from grid as g
    union all (
        with previous_moves as (
            select *
            from moves
        ),
        adjacent_paper as (
            select
                g.row,
                g.col,
                g.item,
                (
                    select count(*)
                    from previous_moves as a
                    where ((a.row = g.row and a.col = g.col - 1)
                    or (a.row = g.row and a.col = g.col + 1)
                    or (a.row = g.row - 1 and a.col = g.col)
                    or (a.row = g.row + 1 and a.col = g.col)
                    or (a.row = g.row - 1 and a.col = g.col - 1)
                    or (a.row = g.row - 1 and a.col = g.col + 1)
                    or (a.row = g.row + 1 and a.col = g.col - 1)
                    or (a.row = g.row + 1 and a.col = g.col + 1)) and a.item = '@' and g.item = '@'
                ) as adjacent_paper,
                g.moved,
                g.iterations
            from previous_moves as g
        )
        select
            g.row,
            g.col,
            case when g.adjacent_paper < 4 and g.item = '@' then '.' else g.item end as item,
            case when g.adjacent_paper < 4 and g.item = '@' then 1 else 0 end as moved,
            g.iterations + 1
        from adjacent_paper as g
        where exists (select 1 from previous_moves as p where p.moved = 1 or p.iterations = 0)
    )
)
select
    (select sum(moved) from moves where iterations <= 1) as solution_part_1,
    (select sum(moved) from moves) as solution_part_2;
