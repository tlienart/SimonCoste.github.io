# This file was generated, do not modify it. # hide
function SOSrep(n::Int)
    """ Returns the list of Sum-Of-Squares representations.
    Returns an empty list if there are none. """
    square_reps = []
    for i in 1:sqrt(n)-1
        if isinteger(sqrt(n - i^2))
            j = sqrt(n - i^2)
            append!(square_reps,  [[i,j], [i,-j], [j,i], [j,-i]])
        end
    end
    if isinteger(sqrt(n))
        j = sqrt(n)
        append!(square_reps, [[0,j], [0, -j], [j, 0], [-j, 0]])
    end
    return square_reps
end