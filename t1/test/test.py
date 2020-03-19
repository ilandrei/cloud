import requests
from statistics import mean, median
import os



def access(url,number_of_times):
    times = []
    for _ in range(number_of_times):
        response = requests.get(url)
        times.append(response.elapsed.microseconds)
    print(times)
    return(mean(times) * (10 ** (0-6)),min(times)* (10 ** (0-6)),max(times)* (10 ** (0-6)))

def test_times():
    root_link = 'http://localhost:42069/'
    request_link = 'http://localhost:42069/api?ip=92.86.185.101'
    number_of_times_root = 50
    number_of_times_request = 5
    message = 'Accessing {} for {} the average time is {}, the min is {} and the max is {}'

    average_time,min_time,max_time = access(root_link,number_of_times_root)
    to_return = message.format(root_link,number_of_times_root,average_time,min_time,max_time) + os.linesep

    average_time,min_time,max_time = access(request_link,number_of_times_request)
    to_return += message.format(request_link,number_of_times_request,average_time,min_time,max_time)
    
    file = open('test.txt','a')
    file.write(to_return)
    
test_times()