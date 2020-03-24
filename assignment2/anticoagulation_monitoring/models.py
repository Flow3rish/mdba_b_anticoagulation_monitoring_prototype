from django.db import models
from django.core.validators import RegexValidator


class Country(models.Model):
    name = models.CharField(max_length=255)

    def __str__(self):
        return f'{self.name}'


class Address(models.Model):
    street = models.CharField(max_length=255, unique=True)
    city = models.CharField(max_length=255)
    province = models.CharField(
        max_length=255, blank=True, null=True, default=None)
    zip_code = models.CharField(max_length=6, validators=[RegexValidator(
        regex='^.{5,6}', message='Zip code has to be 6 characters', code='nomatch')])
    country = models.ForeignKey(Country, on_delete=models.CASCADE)

    def __str__(self):
        add = self.street + '\n'
        add += self.city + '\n'
        if self.province:
            add += self.province + '\n'
        add += self.zip_code + '\n'
        add += str(self.country)
        return add


class Person(models.Model):

    GENDERS = (
        ('M', 'Male'),
        ('F', 'Female')
    )

    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    middle_name = models.CharField(
        max_length=255, blank=True, null=True, default=None)
    gender = models.CharField(max_length=1, choices=GENDERS)
    birth_date = models.DateField()
    address = models.ForeignKey(Address, on_delete=models.PROTECT)
    telephone = models.CharField(
        max_length=15, blank=True, null=True, default=None, unique=True)
    mobile = models.CharField(
        max_length=15, blank=True, null=True, default=None, unique=True)
    email = models.EmailField(blank=True, null=True, default=None, unique=True)

    class Meta:
        abstract = True

    def __str__(self):
        full_name = self.first_name + ' '
        if self.middle_name:
            full_name += self.middle_name + ' '
        full_name += self.last_name
        return f'{self.__class__.__name__} {self.id} | {full_name} [{self.gender}] - born {self.birth_date}'


class Facility(models.Model):
    name = models.CharField(max_length=255)
    address = models.OneToOneField(Address, on_delete=models.PROTECT)

    def __str__(self):
        return f'{self.name}\n{self.address}'


class MedicalStaff(Person):
    employed_at = models.ForeignKey(
        Facility, null=True, on_delete=models.SET_NULL)

    class Meta:
        abstract = True

    def __str__(self):
        return super().__str__() + f' employed at: {self.employed_at.name}'


class Nurse(MedicalStaff):
    pass


class GeneralPractitioner(MedicalStaff):
    pass


class Patient(Person):
    general_practitioner = models.ForeignKey(
        GeneralPractitioner, null=True, on_delete=models.SET_NULL)


# class Hospital(Facility):
    # address = models.ForeignKey(Address, on_delete=models.PROTECT)


# class HospitalDepartment(Facility):
    # address = models.ForeignKey(Address, on_delete=models.PROTECT)


class Anamnesis(models.Model):
    patient = models.OneToOneField(Patient, on_delete=models.CASCADE)


class Drug(models.Model):
    trade_name = models.CharField(max_length=255)
    iupac_name = models.TextField(blank=True, null=True, default=None)


class DrugDosage(models.Model):
    drug = models.ForeignKey(Drug, on_delete=models.CASCADE)
    strength = models.IntegerField(verbose_name='strength in miligrams')


class AnticoagulationRecord(models.Model):
    anamnesis = models.ForeignKey(Anamnesis, on_delete=models.CASCADE)
    drug = models.ForeignKey(Drug, on_delete=models.PROTECT)
    target_inr = models.FloatField()
    treatment_start_date = models.DateField()
    reason_for_treatment = models.TextField()
    treatment_facility = models.ForeignKey(
        Facility, on_delete=models.PROTECT)


class DrugDosageSchedule(models.Model):
    """Drug dosage weekly in miligrams"""
    monday = models.IntegerField()
    tuesday = models.IntegerField()
    wednesday = models.IntegerField()
    thursday = models.IntegerField()
    friday = models.IntegerField()
    saturday = models.IntegerField()
    sunday = models.IntegerField()

    def __str__(self):
        return f'mon: {self.monday}\ntue: {self.tuesday}\nwed: {self.wednesday}\nthu: {self.thursday}\nfri: {self.friday}\nsat: {self.saturday}\nsun: {self.sunday}'


class AnticoagulationRecordEntry(models.Model):
    AnticoagulationRecord = models.ForeignKey(
        AnticoagulationRecord, on_delete=models.CASCADE)
    date = models.DateField()
    inr_measured = models.FloatField()
    drug_dosage_schedule = models.OneToOneField(
        DrugDosageSchedule, on_delete=models.PROTECT)
    comment = models.TextField(blank=True, null=True, default=None)
    # blood sample
    # missed 3 appointments => discharged

