from django.test import TestCase
from anticoagulation_monitoring.models import Patient, GeneralPractitioner, Nurse, Country, Address, Facility


class EntryCreationTestCase(TestCase):
    def setUp(self):
        country_names = [
            'United Kingdom',
            'Czech Republic',
        ]
        self.country_list = [Country.objects.create(
            name=country_name) for country_name in country_names]

        addresses = [
            {
                'street': '2 Firth Street',
                'city': 'Huddersfield',
                'province': 'West-Yorkshire',
                'zip_code': 'HD13BA',
                'country': self.country_list[0]
            },
            {
                'street': 'Zahumenni 152/117',
                'city': 'Ostrava',
                'province': 'Moravian-Silesian',
                'zip_code': '70800',
                'country': self.country_list[1]
            },
            {
                'street': 'Zahumenni 153/117',
                'city': 'Ostrava',
                'province': 'Moravian-Silesian',
                'zip_code': '70800',
                'country': self.country_list[1]
            },
            {
                'street': 'Zahumenni 154/117',
                'city': 'Ostrava',
                'province': 'Moravian-Silesian',
                'zip_code': '70800',
                'country': self.country_list[1]
            }
        ]
        self.address_list = [Address.objects.create(
            **address) for address in addresses]

        facilities = [
            {
                'name': 'FNO antikoagulacni klinika',
                'address': self.address_list[3]
            },
            {
                'name': 'Royal Infirmary',
                'address': self.address_list[2]
            },
        ]

        self.facilities_list = [Facility.objects.create(
            **facility) for facility in facilities]
        gps = [
            {
                'first_name': 'Martin',
                'middle_name': 'Jurijevic',
                'last_name': 'Liberda',
                'gender': 'M',
                'birth_date': '1980-03-01',
                'telephone': '+420555444333',
                'mobile': '+420111222333',
                'address': self.address_list[1],
                'employed_at': self.facilities_list[0]
            },
            {
                'first_name': 'Lenka',
                'last_name': 'Dziobova',
                'gender': 'F',
                'birth_date': '1980-03-01',
                'telephone': '+44078394444',
                'mobile': '+44079999999',
                'address': self.address_list[0],
                'employed_at': self.facilities_list[1]
            }
        ]
        self.gps_list = [
            GeneralPractitioner.objects.create(**gp) for gp in gps]
        print(self.gps_list[0])
        patients = [
            {
                'first_name': 'Vit',
                'last_name': 'Chrubasik',
                'gender': 'M',
                'birth_date': '1996-03-23',
                'address': self.address_list[1],
                'email': 'kopretinka14@seznam.cz',
                'general_practitioner': self.gps_list[0]
            },
            {
                'first_name': 'Alice',
                'last_name': 'Doe',
                'gender': 'F',
                'birth_date': '1993-01-21',
                'address': self.address_list[0],
                'email': 'alice.doe@gmail.com',
                'general_practitioner': self.gps_list[1]
            },
        ]

        self.patients_list = [Patient.objects.create(
            **patient) for patient in patients]

    def test_queries(self):
        pass
