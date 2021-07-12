+++
titlepost = "The dimension of invariant and equivariant linear layers"
date = "July 2021"
abstract = "We compute the dimension of equivariant linear layers in neural architectures."
+++

Neural networks are compositions of linear operatiors and pointwise non-linearities. If the input is ${\bf x}$, then a 2-layers network will look like
\begin{equation}\label{nn} f({\bf x}) = m  \circ \rho \circ L \circ \rho \circ A ~ (\bf x)\end{equation}
where $\rho$ is a pointwise nonlinearity (for example, ReLu), $A, L$ are linear operators and $m$ is a [multi-layer perceptron](https://en.wikipedia.org/wiki/Multilayer_perceptron). 

In many cases, one needs to impose some constraints on how $f$ behaves when $\bf x$ undergoes some symmetry transformation. Typically, a neural network trained to classify images of cats and dogs should produce the same output if tested on an image of a cat, and on the same image but mirrored.

In this note, we give some theoretical results on symmetry-invariance of tensorized neural networks. 

--- 

\toc

---


## Permutations invariance and equivariance

Most neural architectures do not take as inputs one-dimensional vectors, but rather **tensors**, which are just generalized vectors. Let us fix the notations and explain how we define the symmetries of tensors. 

**Tensor notations.** We will only deal with « square tensors », possibly with features. A tensor with order $k$ and dimension $n$ is simply an element of $\mathbb{R}^{n^k}$, seen as an array with $k$ axes each of which has $n$ indices: we will not index its elements with one index from $1$ to $n^k$, but with a multi-index $(i_1, \dotsc, i_k)$, each of them in $[n]$. Vectors are order-1 tensors, matrices are order-2 tensors, and so on. In general, the entries of a tensor are complex numbers, but sometimes they can themselves have a higher dimension, say $a$.
The space of tensors with $k$ axes, $n$ dimensions and features of dimension $a$ can thus be identified with $\mathbb{R}^{n^k \times a}$. 


**Permutation action.** For any permutation $\sigma$ of $[n]$, one can permute the elements of a tensor $X \in \mathbb{R}^{n^k \times a}$ by simply setting
$$ (\sigma * X )_{i_1, \dotsc, i_k, j} = X_{\sigma(i_1), \dotsc, \sigma(i_k), j}.$$
We say that a function $f$ defined on tensors has symmetries with respect to permutations if it behaves well when the permutation acts on the tensor. 

@@important
- **Invariance.** A function $f : \mathbb{R}^{n^k \times a} \to \mathbb{R}$ is called permutation-invariant if $$f(\sigma * X) = f(X).$$ 
- **Equivariance.** A function $f: \mathbb{R}^{n^k \times a } \to \mathbb{R}^{n^h \times b}$ is called permutation-equivariant if 
$$ f(\sigma * X) = \sigma * f(X). $$
@@

Note that for invariance, we restricted to functions which end in $\mathbb{R}$. This is sufficient: invariant functions from $\mathbb{R}^{n^k \times a }$ to $\mathbb{R}^m$ are just composed of $m$ invariant functions. Also, note that for equivariance, one can have an invariant function between tensors of different orders $k \neq h$.
One of the crucial goals of modern (deep) learning is to craft neural architectures which can approximate as well as possible any function with this kind of invariance. An intuitive way of doing so is to concatenate linear layers and non-linearities, as in \eqref{nn}, but in enforcing the linear layers to be themselves invariant or equivariant. It is easily seen that the resulting network will itself be invariant or equivariant. That being said, not all linear operations are permutation-invariant: for instance, the following example shows that there is essentially one linear form which is permutation-invariant. 

## The simplest of examples: invariant linear forms

Let us try to find all the linear operations $L:\mathbb{R}^n \to \mathbb{R}$ that are permutation-invariant. Such operations are simply multiplications by a $n \times 1$ matrix, ie 
$$ L (x) = \sum_{i=1}^n a_i x_i $$
for some numbers $a_i$ that we have to find in such a way that $L(\sigma * x) = L(x)$. Equivalently, we must find the $a_i$ such that for every $x$ and every permutation $\sigma$, the numbers $\sum a_i x_i $ and $\sum a_i x_{\sigma(i)}$ are equal. It is quite easy to see that this can happen only if all the $a_i$ are equal. Indeed, by taking $x$ to be the first elementary vector $e_1 = (1, 0, \dotsc, 0)$ and $\sigma$ to be the transposition $(1,2)$, one sees that $a_1 = L(e_1) = L(\sigma *e_1) = L(e_2) = a_2$  and so on. Consequently, there is essentially only one permutation-equivariant linear form, and it is $L(x) = \sum x_i$ and its multiples.  

Our goal is to push further this example, and identify the invariant/equivariant linear operations in all orders and dimensions. 


## Dimension of invariant layers

We begin with the **dimension** of invariant operations, which can be computed quite easily. The solution involves the [Bell numbers](https://oeis.org/A000110).

**Definition.** The $k$-th Bell number $\mathrm{B}_k$ is the number of partitions of $[k]=\{ 1, \dotsc, k\}$. 
 
To be clear, a partition of $[k]$ is simply a collection of nonempty disjoint sets, say $\pi_1, \dotsc, \pi_r$, such that their union is $[k]$. It is worth mentioning that these numbers are growing extremely fast. With some Julia code and the `Combinatorics` package, one can list all the partitions of $[n]$ with `collect(partitions(1:n))`:
```julia:belldef
using Combinatorics
BellPart(n) = collect(partitions(1:n))
```
 Here is a small picture of all the $\mathrm{B}_4=15$ partitions of $\{1, 2, 3, 4 \}$:

```julia:bell
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

```
\fig{bell}


We now state the main result of this note. 

@@important

**Theorem.** The dimension of permutation-invariant linear layers $\mathbb{R}^{n^k \times a} \to \mathbb{R}$ is $a \times \mathrm{B}_k$. 

@@



*Proof*. Let $\mathscr{V}$ be the vector space of all linear operators from $\mathbb{R}^{n^k \times a}$ to $\mathbb{R}$. For any permutation $\sigma$, let $P_\sigma : \mathbb{R}^{n^k \times a} \to \mathbb{R}^{n^k \times a}$ be the matrix of the action of $\sigma$. By the definition, a linear operator $L \in \mathscr{V}$ is invariant iff $LP_\sigma x = Lx$ for every $x$, in other words iff $LP_\sigma = L$. Consequently, the subspace of invariant operators is  $\mathscr{V}_{\mathrm{fix}} = \{ L :  LP_\sigma = L \text{ for all } \sigma \}$ and we want to compute its dimension. Thanks to a well-known magical trick from group representation theory, it turns out that the projection from $\mathscr{V}$ to $\mathscr{V}_{\mathrm{fix}}$ is given by the *group action average* $\Phi : \mathscr{V} \to \mathscr{V}$ defined by[^1]
$$ \Phi:L \mapsto  \frac{1}{n!}\sum_\sigma LP_\sigma.$$
This is easy to prove: first, check that $\Phi \circ \Phi = \Phi$, so $\Phi$ is a projector, then check that its image is $\mathscr{V}_{\mathrm{fix}}$, which is also not very difficult by double inclusion. Now, the dimension of a subspace is nothing but the trace of its projector, so we want to compute $\mathrm{trace}(\Phi)$, which by linearity is given by
\begin{equation}\label{tr} \frac{1}{n!}\sum_\sigma \mathrm{trace}(L \mapsto LP_\sigma).\end{equation}
By $ \mathrm{trace}(L \mapsto LP_\sigma)$, we mean the trace of the linear operator from $\mathscr{V}$ to $\mathscr{V}$ defined by $L \mapsto LP_\sigma$. Fortunately, it is a classical exercise to check that for any linear operator $A : \mathbb{R}^{n^k \times a} \to \mathbb{R}^{n^k \times a}$, one has $\mathrm{trace}(L \mapsto LA) = \mathrm{trace}(A)$. 

The dimension $\dim(\mathscr{V}_{\mathrm{fix}}) = a \times \mathrm{B}_k$ will follow from two computations, which we state as lemmas because we will use them later for equivariant layers. We recall that the fixed points of a permutation $\sigma$ of $[n]$ are the $i\in [n]$ such that $\sigma(i)=i$. 

@@important
**Lemma 1.** $$\mathrm{trace}(P_\sigma) = a \times (\text{number of fixed points of } \sigma)^k$$ 

**Lemma 2.** $$\frac{1}{n!}\sum_\sigma (\text{number of fixed points of } \sigma)^k = \mathrm{B}_k$$
@@

Given these, the proof of the dimension formula follows directly from \eqref{tr}, Lemma 1 and Lemma 2.

---

*Proof of Lemma 1 (tensorized version).* Check that $P_\sigma$ can actually be written as $M_\sigma \otimes \dots \otimes M_\sigma \otimes I_a$ where $M_\sigma$ is the $n \times n$ permutation matrix of $\sigma$, $\otimes$ is the Kronecker tensor product, then use that the trace is multiplicative with respect to $\otimes$ and that the trace of a permutation matrix is the number of its fixed points.  

*Proof of Lemma 1 (vectorized version).* By definition of the trace, $\mathrm{trace}(P_\sigma) = \sum_{i_1, \dotsc, i_k, j}(P_\sigma)_{(i_1, \dotsc, i_k, j), (i_1, \dotsc, i_k, j)}$. By the definition of $P_\sigma$, 
$$(P_\sigma)_{(i_1, \dotsc, i_k, j), (i'_1, \dotsc, i'_k, j')} = \mathbf{1}_{ \sigma(i_1) = i'_1, \dotsc, \sigma(i_k) = i'_k }$$
and thus we obtain
\begin{align}\mathrm{trace}(P_\sigma) &= \sum_{j=1}^a \left( \sum_{i_1, \dotsc, i_k}\mathbf{1}_{\sigma(i_1) = i_1}\times \dotsc \times \mathbf{1}_{\sigma(i_k) = i_k} \right)\\ 
&= \sum_{j=1}^a \left(\sum_{i=1}^n \mathbf{1}_{\sigma(i) =i}\right)^k \\
&= a \times (\text{number of fixed points of } \sigma)^k.  
\end{align}

*Proof of Lemma 2*. The group of permutations of $[n]$ acts on the set of functions $u$ from $[k] \to [n]$ by $\sigma \star u (k) = \sigma(u(k))$. If $\sigma$ has, say, $z$ fixed points, then there are $z^k$ functions $u$ such that $\sigma \star u = u$: all the functions who only have values in the $z$ fixed points of $\sigma$. [Burnside's formula](https://en.wikipedia.org/wiki/Burnside%27s_lemma) says that 
$$\frac{1}{n!}\sum_{\sigma} (\text{number of }u\text{ such that } \sigma \star u = u  )= \text{ number of orbits of the action } \star. $$   
But the orbits of this action are parametrized by partitions of $[n]$. To see this, just consider the sets $u^{-1}(i)$ for $i \in [n]$. The nonempty ones form a partition of $[k]$, and if two $u,v$ have the same partition, then one will certainly find a $\sigma$ such that $\sigma \star u  = v$...

---




We thus have the dimension of the subspace of invariant linear layers, and the result has something quite stunning... Our theorems say that invariant layers from $\mathbb{R}^{n^k}$ to $\mathbb{R}$ are parametrized by $\mathrm{B}_k$ dimensions... **independently of $n$**. 

@@important
The dimension of invariant linear layers between tensors do not depend on the size of the tensors, but only on the order of the tensors. 
@@

Among other things, a nice consequence is that the learnable parameters are transferable to input tensors with the same order but different sizes! 

## Basis for invariant layers

We also have at our disposal a *basis* for this subspace. A basis of the linear space $\mathscr{V}$ is given by the set of all the $n^k\times a$ elementary « matrices », which can be represented as $E_{i_1, \dotsc, i_k, j}$, the linear operator sending the $(i_1, \dotsc, i_k, j)$ element of the elementary basis of $\mathbb{R}^{n^k\times a }$ onto 1. 

Let $\pi$ be a partition of $[k]$ and consider all the multi-indices $(i_1, \dotsc, i_k)$ which are constant on the blocks of $\pi$; more formally, if $s,t$ are in the same block of $\pi$, then $i_s = i_t$. We note $\mathscr{S}(\pi)$ all those indices (the equivalence class induced by $\pi$). 

@@important

The family
$$F_{\pi, j} =  \sum_{(i_1, \dotsc, i_k) \in \mathscr{S}(\pi) } E_{ i_1, \dotsc, i_k, j}$$
where $\pi$ is a partition of $[k]$ and $j \in [d]$
is a basis of the subspace of permutation-invariant linear operators from $\mathbb{R}^{n^k \times a }$ to $\mathbb{R}$. 
@@

Well, given the previous result, the proof is almost trivial since it is enough to check that the $F_{\pi, j}$ are linearly independent. In fact, one can also prove the theorem by also checking that this family actually generates the subspace of permutation-invariant linear operators!  

One of the main features of this description is that when training neural networks, each linear layer is caracterized by only $a\mathrm{B}_k $ parameters, provided we have at our disposal the hard-coded basis of the $F_{\pi, j}$. 

**Example: Graph-invariant layers**. Let us focus on invariant layers from $\mathbb{R}^{n^2}$ to $\mathbb{R}$. Here, we only seek linear operators taking as input square matrices, and invariant with respect to permutations, ie $L((A_{i,j})) = L((A_{\sigma(i), \sigma(j)}))$ for any permutation $\sigma$. The theorem says that this subspace has only $\mathrm{B}_2 = 2$ dimensions.  The two partitions of $[2]$ are $\{ \{1,2\} \}$ and $\{ \{1\}, \{2\} \}$. The orbit of the first one is simply the set of diagonal couples, $(i,i)$, so the corresponding basis vector will be 
$$F_1 = \sum_{i=1}^n E_{i,i} $$  
This is nothing but the trace operator: $F_1(A) = \sum_i E_{i,i}(A) = \sum_i A_{i,i}$. The orbit of the second partition is the set of non-diagonal couples, ie $(i,j)$ with $i\neq j$. The corresponding basis vector will be 
$$F_2 = \sum_{i \neq j} E_{i,j}. $$
This is the operator $\mathrm{Identity - trace}$. Consequently, all the invariant linear forms on $\mathbb{R}^{n^2}$ have the form
$$ A \mapsto \lambda \times \sum_{i=1}^n A_{i,i} + \mu \times \sum_{i \neq j}A_{i,j}.$$

## Equivariant layers 

Let us now have a look at the same problem, but for equivariance. We seek linear layers from $\mathbb{R}^{n^k, a}$ to $\mathbb{R}^{n^h, b}$ which are **equivariant** with respect to permutations. Note that now, we do not restrict to layers between $\mathbb{R}^{n^k\times d}$ and $\mathbb{R}$. We can even consider layers between tensor spaces of different orders $k \neq h$ and different feature dimensions $a \neq b$.  

@@important

The dimension of permutation-equivariant linear layers $\mathbb{R}^{n^k\times a} \to \mathbb{R}^{n^h \times b}$ is $a\times b \times \mathrm{B}_{k+h}$. 
@@

*Proof*. The proof follows the same lines as for invariant layers, with the difference that the action is not exactly the same. Let us note $\mathscr{V}$ the set of linear operators from $\mathbb{R}^{n^k\times a} \to \mathbb{R}^{n^h \times b}$. A linear operator $L$ is invariant iff $LP_\sigma = P_\sigma L$, so in fact we are interested in the dimension of the subspace $\mathscr{V}_{\mathrm{eq}} = \{ L : P_\sigma^{-1}LP_{\sigma} = L\}$. Here again, this dimension is the trace of the projection operator:
$$\dim (\mathscr{V}_{\mathrm{eq}}) = \frac{1}{n!}\sum_\sigma \mathrm{trace}(L \mapsto P^{-1}_\sigma L P_\sigma).$$
The main difference is that this time, one has $$\mathrm{trace}(L \mapsto P^{-1}_\sigma L P_\sigma) = \mathrm{trace}_{n^k \times a}(P_\sigma)\times \mathrm{trace}_{n^h \times b}(P_\sigma),$$ where the subscripts indicate in which underlying space we're taking the traces. But then, as before, this is equal to 
$$ a\times (\text{number of fixed points of }\sigma)^k \times  b\times (\text{number of fixed points of }\sigma)^h$$
and we can now finish the proof exactly as in the invariant case. 

---

Here again, our remark on dimensions of invariants networks is still valid: the dimension of equivariant networks does not depend on $n$!

For instance, suppose that one has a graph represented by an adjacency matrix (an order-2 tensor), with edge features of dimension 3, and we would like to represent this graph using only node features of dimension, say, 5; additionnally, we want this to be relabelling-equivariant, ie if we chose to label the nodes in a different way, the node features should be permuted accordingly. We thus seek equivariant layers between $\mathbb{R}^{n^2, 3}$ and $\mathbb{R}^{n,5}$ and their dimension is $3 \times 5 \times \mathrm{B}_{2 + 1} = 225$.


We also have a basis for equivariant layers. This time, the elementary basis of the space of linear operators $\mathbb{R}^{n^k \times a} \to \mathbb{R}^{n^h \times b}$ will be noted
$$E_{i_1, \dotsc, i_k, j, i'_1, \dotsc, i'_h, j'}$$
meaning the operator sending the elementary basic vector of $\mathbb{R}^{n^k \times a}$ of index $(i_1, \dotsc, i_k, j)$ to the elementary basic vector of $\mathbb{R}^{n^h \times b}$ of index $(i'_1, \dotsc, i'_h, j')$. If $\pi$ is a partition of the set $[k+h]$, its orbit is the set of all multi-indices $(i_1, \dotsc, i_k, i'_1, \dotsc, i'_h)$ which are constant of its blocks and we note this orbit $\mathscr{S}(\pi)$. Then, just as for the invariant case, summing on the orbits yields a basis of $\mathscr{V}_{\mathrm{eq} }$.  


@@important

The family
$$ \sum_{i_1, \dotsc, i_k, i'_1, \dotsc, i'_h \in \mathscr{S}(\pi) } E_{i_1, \dotsc, i_k, j, i'_1, \dotsc, i'_h, j'} $$
where  $\pi$ is a partition of $[k+h]$, $j \in [a], j'\in [b]$ is a basis of the space of permutation-equivariant linear operators from $\mathbb{R}^{n^k \times a}$ to $\mathbb{R}^{n^h \times b}$. 

@@

**Example: basis for graph equivariant layers**. Let us find all linear operators $\mathbb{R}^{n^2} \to \mathbb{R}^{n^2}$ which are permutation-equivariant. By the theorem above, the dimension is $\mathrm{B}_{2+2} = 15$ and we already saw those partitions in the plot above. Using the preceding description, we can try to plot the basis of the $F_\pi$, which requires a bit of reflection. 

```julia:bell2
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
```
\fig{basis}


I took $n=4$, so the dimension of $\mathbb{R}^{n^2}$ is $16$, and then I represented each operator $\mathbb{R}^{n^2} \to \mathbb{R}^{n^2}$ as a $16 \times 16$ matrix. What you see above are the heatmap of the 15 basis elements of the space of equivariant operators; in the heatmap, yellow = 1 and black = 0. 

## But why ?

One of the goals of deep learning is to craft invariant or equivariant neural architectures for approximating invariant/equivariant functions, and the idea presented in this note was to concatenate several layers of linear invariant/equivariant operators and non-linearities. This will surely yield an invariant/equivariant network... **But can *all* continuous invariant/equivariant functions be approximated by these kind of layers?** This problem, known as the expressivity or universality problem, is not an easy one. Here is a small summary of what seems to be the current state of the art (I'll probably write a more detailed note on these topics): 
- Yes, every continuous invariant function can be approximated by invariants networks as the ones we studied. **But** this might require hidden layers with prohibitive orders: if the original input is $n$-dimensional, one might need tensors of order up to $n(n-1)/2$, which means vectors from a $n^{n(n-1)/2}$-dimensional space... This is obviously not usable for practical purposes. Same thing for equivariant networks. 
- For graphs (order-2 tensors), the most expressive architectures with low-order tensors seem to be the so-called Folklore Graph Neural Networks (FGNN), who incorporate message-passing-like layers (but they are not message-passing networks). 
- There are alternative architectures that are easy to implement, usable, and universal, such as PointNetST or DeepSets. They are often used for ML tasks on 3d point clouds.  



## References

I guess that the dimension of permutation invariant or equivariant linear operators is some kind of folklore problem, but it got digged out of oblivion pretty recently in the context of deep learning; a modern-language proof arose in the [Invariant and equivariant graph networks](https://arxiv.org/abs/1812.09902) wonderful paper (and those which followed by the same group of authors), which seemed to be the first to introduce these invariant networks with concatenations of invariant layers. Most results in my note are inspired by this paper. 

- [Invariant and equivariant graph networks](https://arxiv.org/abs/1812.09902) by Maron, Ben-Hamu, Shamir and Lipman. 

- [On learning sets of symmetric elements](https://arxiv.org/pdf/2002.08599.pdf) by Maron, Litany, Chechik and Fetaya. 

- [On the universality of invariant networks](https://arxiv.org/pdf/1901.09342.pdf) by Maron, Fetaya, Segol and Lipman.

- [On universal equivariant set networks](https://arxiv.org/abs/1910.02421) by Segol and Lipman.

- [Universal Invariant and Equivariant GNN](https://proceedings.neurips.cc/paper/2019/file/ea9268cb43f55d1d12380fb6ea5bf572-Paper.pdf) by Keriven and Peyré.

- [Expressive power of invariant and equivariant GNN](https://arxiv.org/pdf/2006.15646.pdf), by Azizian and Lelarge. 

[^1]: $\Phi$ is a linear operator, itself defined on the space of linear operators from $\mathbb{R}^{n^k \times a} $ to $\mathbb{R}$. Sometimes it's called a *functor*.

