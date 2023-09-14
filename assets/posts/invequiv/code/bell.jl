# This file was generated, do not modify it. # hide
using Plots

function plot_partition(p)
    order = maximum(maximum, p)
    pl = plot(legend=:none, border=:none, axis=nothing, aspect_ratio=:equal,  
    xlim=(-2, 2), ylim=(-2,2))
    for block in p
        circled = [exp(2im*pi*i/order) for i in block]
        scatter!(pl, real(circled), imag(circled), markersize=10)
    end
    return pl
end

parplots = [plot_partition(p) for p in BellPart(4)]
plot(parplots..., layout=(3, 5))
savefig(joinpath(@OUTPUT, "bell.svg"))#hide