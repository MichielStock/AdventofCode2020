#=
Author: Michiel Stock
AoC: day 10

Find the seating pattern
=#
using StatsBase: skipmissing

input = """
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
"""

const bases = [(1,1), (-1,1), (1,-1), (-1,-1),
    (0,1), (0,-1), (1,0), (-1,0)]

function parse_input(input)
    lines = split(rstrip(input), "\n")
    n = length(lines)
    m = length(first(lines))
    function interpret(s)
        s == 'L' && return false
        s == '#' && return true
        return missing
    end
    return [interpret(lines[i][j]) for i in 1:n, j in 1:m]
end

function n_adj(seating, i, j)
    n, m = size(seating)
    n_neigh = 0
    @inbounds for (g, h) in bases
        k, l = i + g, j + h
        ((1 ≤ k ≤ n) && (1 ≤ l ≤ m)) || continue
        occ = seating[k,l]
        !ismissing(occ) && (n_neigh += occ)
    end
    return n_neigh
end
        

function update1!(new_seating, seating)
    @assert size(new_seating) == size(seating)
    n, m = size(seating)
    @inbounds for j in 1:m, i in 1:n
        occ = seating[i,j]
        ismissing(occ) && continue
        n_neigh = n_adj(seating, i, j)
        if !occ && (n_neigh==0)
            new_seating[i,j] = true
        elseif occ && n_neigh ≥ 4
            new_seating[i,j] = false
        else
            new_seating[i,j] = occ
        end
    end
    return new_seating
end

function n_occ_seen(seating, i, j)
    n, m = size(seating)
    n_occ = 0
    @inbounds for (g, h) in bases
        k, l = i, j
        while true
            k += g
            l += h
            ((1 ≤ k ≤ n) && (1 ≤ l ≤ m)) || break
            if !ismissing(seating[k, l]) 
                n_occ += seating[k, l]
                break
            end
        end
    end
    return n_occ
end
            

function update2!(new_seating, seating)
    @assert size(new_seating) == size(seating)
    n, m = size(seating)
    @inbounds for j in 1:m, i in 1:n
        occ = seating[i,j]
        ismissing(occ) && continue
        n_neigh = n_occ_seen(seating, i, j)
        if !occ && (n_neigh==0)
            new_seating[i,j] = true
        elseif occ && n_neigh ≥ 5
            new_seating[i,j] = false
        else
            new_seating[i,j] = occ
        end
    end
    return new_seating
end

update2(seating) = update2!(copy(seating), seating)

function eq_seating(seating, update!)
    n_places = seating |> skipmissing |> sum
    seating = copy(seating)
    new_seating = copy(seating)
    while true
        new_seating = update!(new_seating, seating)
        n_places_new = new_seating |> skipmissing |> sum
        changed = (new_seating .!= seating) |> skipmissing |> any
        !changed && return seating
        n_places = n_places_new
        new_seating, seating = seating, new_seating
    end
end

input = read("data/11_seating_system/input.txt", String);
seating = parse_input(input)

n_chairs = eq_seating(seating, update1!) |> skipmissing |> sum

n_chairs2 = eq_seating(seating, update2!) |> skipmissing |> sum