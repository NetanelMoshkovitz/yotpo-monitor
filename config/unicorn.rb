worker_processes 30
timeout 300
preload_app true

@app_path = '/Users/netanel/Development/yotpo-workspace/yotpo-monitor'
listen "#{@app_path}/tmp/sockets/unicorn.sock", :backlog => 64
pid "#{@app_path}/tmp/pids/unicorn.pid"
