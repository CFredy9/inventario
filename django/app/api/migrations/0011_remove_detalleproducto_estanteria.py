# Generated by Django 2.2.13 on 2022-01-14 04:30

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0010_auto_20220113_2228'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='detalleproducto',
            name='estanteria',
        ),
    ]