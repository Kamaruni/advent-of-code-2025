\i src/prelude.sql
copy raw_lines (line) from '../input/day04.txt';

with grid as (
    select line_no as row, row_coordinates.col, row_coordinates.item
    from raw_lines, regexp_split_to_table(line, '') with ordinality as row_coordinates(item, col)
),
paper_with_adjacent_rolls as (
    select
        g.row,
        g.col,
        g.item,
        (
            select count(*)
            from grid a
            where ((a.row = g.row and a.col = g.col - 1)
            or (a.row = g.row and a.col = g.col + 1)
            or (a.row = g.row - 1 and a.col = g.col)
            or (a.row = g.row + 1 and a.col = g.col)
            or (a.row = g.row - 1 and a.col = g.col - 1)
            or (a.row = g.row - 1 and a.col = g.col + 1)
            or (a.row = g.row + 1 and a.col = g.col - 1)
            or (a.row = g.row + 1 and a.col = g.col + 1)) and a.item = '@'
        ) as adjacent_paper
    from grid as g
    where g.item = '@'
)
select count(*)
from paper_with_adjacent_rolls
where adjacent_paper < 4
