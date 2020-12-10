#=
Author: Michiel Stock
AoC: day 1

Find two numbers in a list that sum together to 2020. 
Return the product of these numbers.
=#

using Test

const year = 2020



example = [1721, 979, 366, 299, 675, 1456]

function product_pairs(numbers)
    for (i, x) in enumerate(numbers)
        for (j, y) in enumerate(numbers)
            (x + y == year) && x != y && return x * y
        end
    end
end

function product_triples(numbers)
    for (i, x) in enumerate(numbers)
        for (j, y) in enumerate(numbers)
            for (k, z) in enumerate(numbers)
                (x + y + z == year) && (x != y != z) && return x * y * z
            end
        end
    end
end

#@test product_pairs(example) == 514579

function parse_file(fn)
    open(fn, "r") do f
        global numbers = [parse(Int, rstrip(l)) for l in eachline(f)]
    end
    return numbers
end

numbers = parse_file("data/1_report_repair/input.txt")

solution_pairs = product_pairs(numbers)
println("the solution for the pairs is: $solution_pairs. I copied it to the clipboard for you!")
#clipboard(solution_pairs)

solution_triples = product_triples(numbers)
println("the solution for the triples is: $solution_triples. I copied it to the clipboard for you!")
#clipboard(solution_triples)
