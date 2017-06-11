function t = parallel_example(nLoopIters, sleepTime) 
  t0 = tic; 
  parfor idx = 1:nLoopIters 
    A(idx) = idx; 
    pause(sleepTime); 
  end 
  t = toc(t0); 
