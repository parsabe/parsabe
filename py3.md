Steps to Replace Python 3.12 with Python 3.11
```bash
sudo apt update
sudo apt install -y build-essential checkinstall zlib1g-dev libncurses5-dev libgdbm-dev libnssl-dev libreadline-dev libffi-dev
wget https://www.python.org/ftp/python/3.11.0/Python-3.11.0.tgz
tar -xvzf Python-3.11.0.tgz
cd Python-3.11.0
./configure --enable-optimizations
sudo make altinstall


```
Remove Python 3.12

Now that Python 3.11 is installed, you can proceed to remove Python 3.12. Be cautious with this step, as removing system Python can sometimes affect system tools. Use the following command:

```bash
sudo apt remove python3.12
sudo apt autoremove
```
Point python3 to Python 3.11

After removing Python 3.12, you’ll need to ensure that python3 now points to Python 3.11. You can do this by setting up update-alternatives:

```bash
sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.11 1
```

Verify the Default Python Version

Finally, check if python3 is pointing to Python 3.11:

```bash
python3 --version
```

