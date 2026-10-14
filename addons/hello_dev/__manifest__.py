{
    'name': 'Hello Dev',
    'version': '20.0.1.0.0',
    'summary': 'Modul contoh untuk lingkungan pengembangan Odoo 20',
    'category': 'Tools',
    'license': 'LGPL-3',
    'depends': ['base'],
    'data': [
        'security/ir.model.access.csv',
        'views/dev_note_views.xml',
    ],
    'application': True,
    'installable': True,
}
