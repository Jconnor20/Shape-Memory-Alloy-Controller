% Create a new Simulink model
new_system('brinsonSMA');
open_system('brinsonSMA');

% Add a Step block for the input temperature
add_block('simulink/Sources/Step', 'brinsonSMA/Step');

% Add Gain blocks to represent transformation temperatures
add_block('simulink/Math Operations/Gain', 'brinsonSMA/A_s');
add_block('simulink/Math Operations/Gain', 'brinsonSMA/A_f');
add_block('simulink/Math Operations/Gain', 'brinsonSMA/M_s');
add_block('simulink/Math Operations/Gain', 'brinsonSMA/M_f');

% Add Sum blocks to combine inputs for each equation
add_block('simulink/Math Operations/Sum', 'brinsonSMA/Sum1');
add_block('simulink/Math Operations/Sum', 'brinsonSMA/Sum2');

% Set parameters
set_param('brinsonSMA/Step', 'Time', '0'); % step time
set_param('brinsonSMA/A_s', 'Gain', '0'); % austenite start temperature
set_param('brinsonSMA/A_f', 'Gain', '0'); % austenite finish temperature
set_param('brinsonSMA/M_s', 'Gain', '0'); % martensite start temperature
set_param('brinsonSMA/M_f', 'Gain', '0'); % martensite finish temperature

% Connect the blocks
add_line('brinsonSMA', 'Step/1', 'Sum1/1');
add_line('brinsonSMA', 'A_s/1', 'Sum1/2');
add_line('brinsonSMA', 'A_f/1', 'Sum2/1');
add_line('brinsonSMA', 'M_s/1', 'Sum2/2');

% Save and close the model
save_system('brinsonSMA');
close_system('brinsonSMA');
