import sys
from subprocess import Popen, PIPE
from time import time
from datetime import datetime

argv = sys.argv[1:]

TMUX_COMMAND = ['tmux', 'new', '-d']
TIME_COMMAND = ['time', '-f', 'Time spent: %E']
HIVE_COMMAND = ['hive']
HIVE_OPTIONS = ['-hiveconf', 'hive.query.max.partition=1000']


def common_query_commands():
    return HIVE_COMMAND + HIVE_OPTIONS

def construct_exp_query(query):
    return common_query_commands() + ['-e', query]

def construct_file_query(query):
    return common_query_commands() + ['-f', query]

def construct_time_str(tds):
    day_in_s = 3600 * 24
    hour_in_s = 3600
    minute_in_s = 60
    days = tds / day_in_s
    hours = tds % day_in_s / hour_in_s
    minutes = tds % hour_in_s / minute_in_s
    seconds = tds % minute_in_s
    time_spent_str = "Time spend: %d days, %d hours, %d minutes, %d seconds" % (days, hours, minutes, seconds)
    return time_spent_str

def do_query(query):
    start_time = time()
    p = Popen(query, stdout=PIPE)
    result, err = p.communicate()
    end_time = time()
    tds = end_time - start_time
    time_spent_str = construct_time_str(tds)
    return result, time_spent_str

def do_query_to_file(query, filename, rw):
    result, time_spent_str = do_query(query)
    with open(filename, rw) as f:
        f.write(time_spent_str + '\n')
        f.write('Result:\n')
        f.write(result + '\n')
    print time_spent_str
    print result
    print 'output saved to ' + filename

def main():
    if argv[0] == '-e':
        query = argv[1]
        _t = str(int(time()))
        hive_filename = _t + '.hive'
        with open(hive_filename, 'a') as f:
            f.write(query + '\n' * 2)
        do_query_to_file(construct_exp_query(query), hive_filename, 'a')
    elif argv[0] == '-f':
        filename = argv[1]
        output_filename = filename + '.result'
        do_query_to_file(construct_file_query(filename), output_filename, 'w')

if __name__ =='__main__':
    main()
