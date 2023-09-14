# This file was generated, do not modify it. # hide
isequal(x) = all(y -> y==x[1], x) #checks if all the elements of array x are equal
is_constant_on_blocks(x, P) = prod([isequal(x[block]) for block in P]) 
zeros_t(n,k) = zeros(tuple(n*ones(Int, k)...))# creates a tensor with k axes and n dims

function lifting(P, c, tensor_order)
    out = zeros(Int, tensor_order)
    for i in 1:length(P) 
        a = c[i] * ones(length(P[i]))
        out[P[i]] = a #c[i] * ones(length(P[i]))
    end
    return CartesianIndex(Tuple(out))
end

function create_basic_element(partition,n)
    tensor_order = maximum(maximum, partition)
    x = zeros_t(n,tensor_order)
    for c in CartesianIndices(zeros_t(n,length(partition)))
        cc = lifting(partition, c, tensor_order)
        x[cc]=1
    end
    return x
end

function custom_heatmap(mat)
    #some code for a beautiful heatmap
    output = heatmap(mat, aspect_ratio = 1, legend = :none, axis = nothing, border = :none, c = :speed)#hide
    return output #hide
end

k=2 ; n=4
basis = [create_basic_element(p, n) for p in BellPart(n)]
hmaps = [custom_heatmap(reverse(reshape(x, n^k, n^k), dims=1)) for x in basis]
plot(hmaps..., layout=(3,5))
savefig(joinpath(@OUTPUT, "basis.svg")) #hide