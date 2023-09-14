# This file was generated, do not modify it. # hide
X(θ, φ) = (2 + cos(θ)) * cos(φ)#hide
Y(θ, φ) = (2 + cos(θ)) * sin(φ)#hide
Z(θ, φ) = sin(θ)#hide
ε = 0.01
t = 0:ε:2π+ε ; u = 0:ε:2π+ε
x = [X(θ, φ) for θ in t, φ in u]
y = [Y(θ, φ) for θ in t, φ in u]
z = [Z(θ, φ) for θ in t, φ in u]