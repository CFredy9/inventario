# Generated by Django 2.2.13 on 2022-01-14 04:28

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0009_detallegasto_gasto'),
    ]

    operations = [
        migrations.AlterField(
            model_name='detalleproducto',
            name='estanteria',
            field=models.ForeignKey(blank=True, on_delete=django.db.models.deletion.CASCADE, related_name='estan', to='api.Estanteria'),
        ),
    ]