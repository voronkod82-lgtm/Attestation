import tkinter as tk
from tkinter import ttk, messagebox
import json
from datetime import datetime

# Глобальные переменные
DATA_FILE = "data.json"
expenses = []

# Загрузка данных из JSON при старте
def load_data():
    try:
        with open(DATA_FILE, 'r', encoding='utf-8') as file:
            return json.load(file)
    except FileNotFoundError:
        return []

# Сохранение данных в JSON
def save_data():
    with open(DATA_FILE, 'w', encoding='utf-8') as file:
        json.dump(expenses, file, indent=4, ensure_ascii=False)

# Валидация ввода
def validate_input(desc, category, amount):
    if not desc or not category or not amount:
        messagebox.showerror("Ошибка", "Все поля обязательны!")
        return False
    try:
        float(amount)
    except ValueError:
        messagebox.showerror("Ошибка", "Сумма должна быть числом!")
        return False
    return True

# Добавление расхода
def add_expense():
    desc = desc_entry.get().strip()
    category = category_entry.get().strip()
    amount = amount_entry.get().strip()

    if validate_input(desc, category, amount):
        expense = {
            "description": desc,
            "category": category,
            "amount": float(amount),
            "date": datetime.now().strftime("%d.%m.%Y")
        }
        expenses.append(expense)
        save_data()
        update_table()
        clear_fields()

# Обновление таблицы
def update_table():
    tree.delete(*tree.get_children())
    for item in expenses:
        tree.insert("", "end", values=(
            item["date"],
            item["description"],
            item["category"],
            f"{item['amount']:.2f}"
        ))

# Очистка полей
def clear_fields():
    desc_entry.delete(0, tk.END)
    category_entry.delete(0, tk.END)
    amount_entry.delete(0, tk.END)

# Инициализация GUI
root = tk.Tk()
root.title("Трекер расходов")
root.geometry("600x400")

# Загрузка данных
expenses = load_data()

# Создание виджетов
tk.Label(root, text="Описание:").grid(row=0, column=0, padx=5, pady=5)
desc_entry = tk.Entry(root, width=30)
desc_entry.grid(row=0, column=1, padx=5, pady=5)

tk.Label(root, text="Категория:").grid(row=1, column=0, padx=5, pady=5)
category_entry = tk.Entry(root, width=30)
category_entry.grid(row=1, column=1, padx=5, pady=5)

tk.Label(root, text="Сумма (руб.):").grid(row=2, column=0, padx=5, pady=5)
amount_entry = tk.Entry(root, width=30)
amount_entry.grid(row=2, column=1, padx=5, pady=5)

# Кнопка
add_btn = tk.Button(root, text="Добавить расход", command=add_expense)
add_btn.grid(row=3, column=0, columnspan=2, pady=10)

# Таблица
tree = ttk.Treeview(root, columns=("Дата", "Описание", "Категория", "Сумма"), show="headings")
tree.heading("Дата", text="Дата")
tree.heading("Описание", text="Описание")
tree.heading("Категория", text="Категория")
tree.heading("Сумма", text="Сумма (руб.)")
tree.grid(row=4, column=0, columnspan=2, padx=5, pady=5, sticky="nsew")

# Растягивание таблицы при изменении размера окна
root.grid_rowconfigure(4, weight=1)
root.grid_columnconfigure(1, weight=1)

# Первоначальное заполнение таблицы
update_table()

root.mainloop()
