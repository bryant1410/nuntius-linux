/*
 * Copyright (C) 2015 - Holy Lobster
 *
 * Nuntius is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Nuntius is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Nuntius. If not, see <http://www.gnu.org/licenses/>.
 */

namespace Nuntius {

public class NotificationApp : Object {
    private string _id;
    private string _app_name;
    private BytesIcon _icon;
    private uint _unread_notifications;
    List<Notification> _notifications;

    public string id {
        get { return _id; }
        set construct { _id = value; }
    }

    public string app_name {
        get { return _app_name; }
    }

    public BytesIcon icon {
        get { return _icon; }
    }

    public uint unread_notifications {
        get { return _unread_notifications; }
    }

    public List<Notification> notifications {
        get { return _notifications; }
    }

    public NotificationApp(string id) {
        Object(id: id);
    }

    construct {
        _notifications = new List<Notification>();
    }

    public void add_notification(Notification notification) {
        _notifications.prepend(notification);

        // Update the icon with the latest notification
        if (_icon != notification.icon) {
            _icon = notification.icon;
            notify_property("icon");
        }

        if (_app_name != notification.app_name) {
            _app_name = notification.app_name;
            notify_property("app-name");
        }

        if (!notification.read) {
            _unread_notifications++;
            notify_property("unread-notifications");
        }

        notification.notify["read"].connect(() => {
            if (notification.read) {
                _unread_notifications--;
            } else {
                _unread_notifications++;
            }

            notify_property("unread-notifications");
        });
    }

    public Notification get_notification(string id) {
        Notification? n = null;

        foreach (var notif in _notifications) {
            if (notif.id == id) {
                n = notif;
                break;
            }
        }

        return n;
    }
}

} // namespace Nuntius

/* ex:set ts=4 et: */
