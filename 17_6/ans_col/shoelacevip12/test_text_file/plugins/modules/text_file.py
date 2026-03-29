#!/usr/bin/python

# GNU General Public License v3.0+

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: text_file

short_description: Создание текстового файла с указанным содержимым

version_added: "1.0.0"

description:
    - Создает текстовый файл на удаленном хосте. 
    - Если файл существует, он будет перезаписан только в том случае, если его содержимое отличается от исходного..

options:
    path:
        description:
            - Полный путь к файлу для создания.
        required: true
        type: str
    content:
        description:
            - Текстовое содержание для записи в файл.
        required: true
        type: str

author:
    - shoelacevip12@gmail.com
'''

EXAMPLES = r'''
- name: Create a text file
  text_file:
    path: /tmp/example.txt
    content: "Hello, Ansible!"
'''

RETURN = r'''
changed:
    description: Если файл создан или изменен.
    type: bool
    returned: always
path:
    description: Полный Путь к файлу.
    type: str
    returned: always
'''

import os
from ansible.module_utils.basic import AnsibleModule


def run_module():
    module_args = dict(
        path=dict(type='str', required=True),
        content=dict(type='str', required=True)
    )

    result = dict(
        changed=False,
        failed=False,
        path=''
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    path = module.params['path']
    content = module.params['content']

    result['path'] = path

    file_exists = os.path.exists(path)
    current_content = ''
 
    if file_exists:
        try:
            with open(path, 'r') as f:
                current_content = f.read()
        except Exception as e:
            module.fail_json(msg=f"Failed to read existing file: {e}", **result)

    if not file_exists or current_content != content:
        result['changed'] = True

        if module.check_mode:
            module.exit_json(**result)

        try:
            with open(path, 'w') as f:
                f.write(content)
        except Exception as e:
            module.fail_json(msg=f"Failed to write file: {e}", **result)

    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
