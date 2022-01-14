# Generated by Django 2.2.13 on 2021-12-08 05:21

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_ubicacion'),
    ]

    operations = [
        migrations.CreateModel(
            name='Estanteria',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('estanteria', models.CharField(max_length=50)),
                ('activo', models.BooleanField(default=True)),
                ('creado', models.DateTimeField(auto_now_add=True)),
                ('modificado', models.DateTimeField(auto_now=True)),
                ('almacen', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='ubicacion', to='api.Ubicacion')),
            ],
        ),
    ]