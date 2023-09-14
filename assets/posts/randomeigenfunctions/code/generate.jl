# This file was generated, do not modify it. # hide
function generate_RAW(n::Int)
    Λ = SOSrep(n)
    if isempty(Λ)
        return nothing
    else
        E = [(x,y) -> exp(2im*pi*(λ[1]*x + λ[2]*y)) for λ in Λ] #exponentials
        X = [randn() + 1im*randn() for λ in Λ]
        f(x,y) = sum(real(X.*[e(x,y) for e in E])) / sqrt(length(Λ))
        return f
    end
end
f = generate_RAW(85) #hide