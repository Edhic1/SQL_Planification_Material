"""
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.

i use gunicorn for production deployment WSGI server

for run it do : gunicorn app:app -c gunicorn_config.py

gunicorn connection4:connection4 -c gunicorn_config.py 
"""

bind = '127.0.0.1:8000'  # Replace with the IP address and port number you want to use
# Replace with the number of worker processes you want to use (4 is a good default)
workers = 4
