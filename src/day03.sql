\i src/prelude.sql
copy raw_lines (line) from '../input/day03.txt';

with banks as (
    select line_no as bank_no, bank.*
    from raw_lines, regexp_split_to_table(line, '') with ordinality as bank(joltage, battery_no)
),
possible_battery_combos as (
    select
        bank.bank_no,
        bank.joltage,
        (
            select max(other.joltage)
            from banks as other
            where bank.bank_no = other.bank_no
              and bank.battery_no < other.battery_no
        ) as max_combo
    from banks as bank
),
best_battery_combos as (
    select bank_no, max((joltage || max_combo)::bigint) best_joltage
    from possible_battery_combos
    group by bank_no
)
select sum(best_joltage) from best_battery_combos;
