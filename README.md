# CGL_phase_transitions

Fun study of phase transitions in Conway's Game of Life with structural perturbation.
The structural perturbation is introduced in the form of asynchronous update, tuned by the asynchronous parameter a. In practice, at each update, a cell is updated with probability a or it remains in the same state with probability 1 - a, thus a \in [0, 1].
This update rule with parameter a is included in the function M-file async_update.m.

In the second code cell of M-file CGL_async_simulation.m, the average density average_rho_array is computed for different parameters a once the systems has reached an approximate
steady state. The steady state is only qualitatively defined in the literature [1, 2]. Thus, we assume the system to be in a steady state after approximately 1000 asynchronous updates.

## References
[1] N. Fatès, "Does Life Resist Asynchrony?" Springer London, 2010.

[2] R. Blok and B. Bergersen, "Synchronous versus asynchronous updating in the \game of life", Phys. Rev. E, vol. 59, 04 1999.
