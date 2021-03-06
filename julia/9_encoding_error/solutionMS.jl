#=
Author: Michiel Stock
AoC: day 9

Check if a number is the
=#


parse_int(s) = parse(Int, s)
parse_input(input) = split(rstrip(input), "\n") .|> parse_int

function check_sum(numbers, pos, indstart, indend)
    @assert indstart < indend
    num = numbers[pos]
    @inbounds for i in indstart:(indend-1)
        @inbounds for j in (indstart+1):indend
            (numbers[i] + numbers[j] == num) && return true
        end
    end
    return false
end

function check_list(numbers, k)
    n = length(numbers)
    @inbounds for pos in (k+1):n
        check = check_sum(numbers, pos, pos-k, pos-1) 
        !check && return numbers[pos]
    end
end

function find_contiguous_sum(numbers, total)
    numb_cumsum = cumsum(numbers)
    n = length(numbers)
    @inbounds for k in 1:n
        @inbounds for i in 1:(n-k)
            running_total = (numb_cumsum[i+k] - numb_cumsum[i] + numbers[i])
            (running_total == total) && return i, i+k
        end
    end
end

numbers = read("data/9_encoding_error/input.txt", String) |> parse_input

num_no_match = check_list(numbers, 25)
i, j = find_contiguous_sum(numbers, num_no_match)
subset = numbers[i:j]
sum(subset) == num_no_match

solution = minimum(subset) + maximum(subset)