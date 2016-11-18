    class File(object):

        def __init__(self, filename):
            self.name = filename
            self.base_name, self.extension = File.splitname(filename)

        @staticmethod
        def splitname(filename):
            '''
                    >> In [1]: splitname('file.avi')
                       ('file', 'avi')
                    >> In [2]: splitname('.file')
                       ('.file', '')
                    >> In [1]: splitname('abc.def.ghi')
                       ('abc.def', 'ghi')
            '''
            last_dot_index = filename.rfind('.')
            if last_dot_index < 1:
                return filename, ''
            return (filename[:last_dot_index],
                    filename[last_dot_index + 1:])

        def get_next(self):

            candidates = [file_ for file_
                                    in os.listdir('.')
                                    if self.filename in file_]
            if len(candidates) == 0:
                return self.filename

            base_name, extension = self.splitname(self.name)

            def make_str(base_name, format_, extension):
                '''
                re.search to read: r'\d+'
                str.format to write: '{version}'
                '''
                if not extension:
                    return '{}({})'.format(base_name, format_)
                return '{}({}).{}'.format(base_name, format_, extension, version)

            version = set()
            regex = make_str(base_name, r'(\d+)', extesion)
            for cand in canditates:
                version
            higher_version = [int(*r.groups()) for r in ]
            filename = make_str(base_name)


    print File(file_).splitname(file_)
                
