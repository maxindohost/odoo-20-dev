from odoo import fields, models


class DevNote(models.Model):
    _name = 'dev.note'
    _description = 'Dev Note'
    _order = 'id desc'

    name = fields.Char(required=True)
    description = fields.Text()
    state = fields.Selection(
        [('draft', 'Draft'), ('done', 'Done')],
        default='draft', required=True,
    )
    active = fields.Boolean(default=True)

    def action_done(self):
        self.write({'state': 'done'})
