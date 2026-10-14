from odoo.tests import TransactionCase, tagged


@tagged('post_install', '-at_install')
class TestDevNote(TransactionCase):

    def test_action_done(self):
        note = self.env['dev.note'].create({'name': 'Test'})
        self.assertEqual(note.state, 'draft')
        note.action_done()
        self.assertEqual(note.state, 'done')
