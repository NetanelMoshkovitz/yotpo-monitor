worker_processes 3
timeout 300
preload_app true

@app_path = '/Users/netanel/Development/yotpo-workspace/yotpo-monitor'
if ENV['RACK_ENV']=="production"
  @app_path = './'
end
listen "#{@app_path}/tmp/sockets/unicorn.sock", :backlog => 64
pid "#{@app_path}/tmp/pids/unicorn.pid"
