worker_processes 4
timeout 300

@app_path = '/Users/netanel/Development/yotpo-workspace/yotpo-monitor'
listen "#{@app_path}/tmp/sockets/unicorn.sock", :backlog => 64
pid "#{@app_path}/tmp/pids/unicorn.pid"
