module ValidateRCall
using Compat: @warn

# Environment variable to avoid boring R package builds
mustCrossvalidate = haskey(ENV, "JULIA_MUST_CROSSVALIDATE") && ENV["JULIA_MUST_CROSSVALIDATE"] == "1"

# Only run R on unix or when R is installed because JULIA_MUST_CROSSVALIDATE is set to 1
skipR = !mustCrossvalidate &&
    !((VERSION < v"0.7.0-" && is_unix()) ||
      (VERSION >= v"0.7.0-" && Sys.isunix()))
global success = false
try
    skipR && error("Skipping R testing...")
    using RCall
    global success = true
catch
    if mustCrossvalidate && VERSION < v"0.7.0-"
        error("R not installed, but JULIA_MUST_CROSSVALIDATE is set")
    else
        @warn "R or appropriate Phylo package not installed, skipping R cross-validation."
    end
end

success && include("run_rcall.jl")

end