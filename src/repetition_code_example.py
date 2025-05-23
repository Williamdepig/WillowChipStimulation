import stim
import numpy as np
import pymatching
import scipy
import sinter
import os

def count_logical_errors(circuit: stim.Circuit, num_shots: int) -> int:
    # 1. Sample the circuit.
    sampler = circuit.compile_detector_sampler()
    detection_events, observable_flips = sampler.sample(num_shots, separate_observables=True)

    # 2. Configure a decoder using the circuit.
    detector_error_model = circuit.detector_error_model(decompose_errors=True)
    matcher = pymatching.Matching.from_detector_error_model(detector_error_model)

    # 3. Run the decoder.
    predictions = matcher.decode_batch(detection_events)

    # 4. Count the mistakes.
    num_errors = 0
    for shot in range(num_shots):
        actual_for_shot = observable_flips[shot]
        predicted_for_shot = predictions[shot]
        if not np.array_equal(actual_for_shot, predicted_for_shot):
            num_errors += 1
    return num_errors


# Example usage
noise = 0.1
circuit = stim.Circuit.generated(
    "repetition_code:memory",
    rounds= 10,
    distance= 5,
    before_round_data_depolarization=noise,
    before_measure_flip_probability=noise
)
num_shots = 100000
num_logical_errors = count_logical_errors(circuit, num_shots)
print("there were", num_logical_errors, "wrong predictions (logical errors) out of", num_shots, "shots")