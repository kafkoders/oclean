from setuptools import setup

setup(
    name="nasa_space_app",
    version="0.1",
    description="Backend for nasa space apps",
    author="kafkoders",
    license="copyright",
    url="https://2019.spaceappschallenge.org",
    packages=['models'],
    install_requires=[
        'Flask==1.1.1',
        'flask_swagger_ui',
        "pymysql"
    ]
)