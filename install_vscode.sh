echo == INSTALLING CODE-SERVER ==
export HOME=/home/ec2-user
curl -fsSL https://code-server.dev/install.sh | sh -s -- --version=4.15.0  # https://github.com/coder/code-server/releases
# So far Amazon 2 Linux only has GLIBC version of 2.26 and we can't run code-server > 4.15.0

#########################################
### INTEGRATE CODE-SERVER WITH JUPYTER
#########################################
echo == UPDATING THE JUPYTER SERVER CONFIG ==
cat >>/home/ec2-user/.jupyter/jupyter_notebook_config.py <<EOC
c.ServerProxy.servers = {
  'vscode': {
      'launcher_entry': {
            'enabled': True,
            'title': 'VS Code',
      },
      'command': ['code-server', '--auth', 'none', '--disable-telemetry', '--bind-addr', '0.0.0.0:{port}'],
      'environment' : {'XDG_DATA_HOME' : '/home/ec2-user/SageMaker/vscode-config'},
      'absolute_url': False,
      'timeout': 30
  }
}
EOC


echo == INSTALL SUCCESSFUL. RESTARTING JUPYTER ==
# RESTART THE JUPYTER SERVER
sudo systemctl restart jupyter-server
echo == JUPYTER SERVER RESTARTED ==
